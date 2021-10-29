import os
from datetime import datetime
import burp
from burp import IBurpExtender, IParameter
from burp import IScannerCheck
from burp import IScanIssue
from array import array

GREP_STRING = "Page generated by:"
GREP_STRING_BYTES = bytearray(GREP_STRING)
INJ_TEST = bytearray("|")
INJ_ERROR = "Unexpected pipe"
INJ_ERROR_BYTES = bytearray(INJ_ERROR)
SUPPORT_PARAMETER_TYPES = [IParameter.PARAM_URL, IParameter.PARAM_BODY, IParameter.PARAM_MULTIPART_ATTR, IParameter.PARAM_JSON \
        ,IParameter.PARAM_XML, IParameter.PARAM_XML_ATTR]

if not os.path.exists('logs'):
    os.mkdir('logs')

f = os.path.join('logs', 'log.txt')
fp = open(f, 'a', buffering=0)
now = datetime.now().strftime("%m/%d/%Y, %H:%M:%S")
startat = '{} Started\n'.format(now)
fp.write(startat)
print(startat)

import sys
import inspect
def cprint(prefix, c):
    for m in dir(c):
        if m.startswith(prefix):
            target = getattr(c, m)
            sys.stdout.write(m + ": ")
            if inspect.ismethod(target):
                r = target()
                print(r)
            else:
                r = target
                print(r)

class BurpExtender(IBurpExtender, IScannerCheck):

    #
    # implement IBurpExtender
    #
    def registerExtenderCallbacks(self, callbacks):
        # keep a reference to our callbacks object
        self._callbacks = callbacks

        # obtain an extension helpers object
        self._helpers = callbacks.getHelpers()

        # set our extension name
        callbacks.setExtensionName("XSS Reflector")

        # register ourselves as a custom scanner check
        callbacks.registerScannerCheck(self)

    # helper method to search a response for occurrences of a literal match string
    # and return a list of start/end offsets

    def _get_matches(self, response, match):
        matches = []
        start = 0
        reslen = len(response)
        matchlen = len(match)
        while start < reslen:
            start = self._helpers.indexOf(response, match, True, start, reslen)
            if start == -1:
                break
            matches.append(array('i', [start, start + matchlen]))
            start += matchlen

        return matches

    #
    # implement IScannerCheck
    #
    def checkXSS(self, baseRequestResponse, headers, params):
        req_raw = baseRequestResponse.getRequest()
        req_raw_str = self._helpers.bytesToString(baseRequestResponse.getRequest())
        res = baseRequestResponse.getResponse()
        offset = self._helpers.analyzeResponse(res).getBodyOffset()
        body = self._helpers.bytesToString(res)[offset:]
        xss_payload = "\"'>TTT"

        def verify(test_req_raw, payload, attack_vector):
            test_base = self._callbacks.makeHttpRequest(baseRequestResponse.getHttpService(), bytearray(test_req_raw, encoding="utf-8"))
            test_res = test_base.getResponse()
            test_body_offset = self._helpers.analyzeResponse(test_res).getBodyOffset()
            test_raw = self._helpers.bytesToString(test_res)
            s_index = self._helpers.indexOf(test_res, payload, True, test_body_offset, len(test_res))
            if s_index == -1: # not founded
                return

            try:
                reflected_value = test_res[s_index:s_index+len(payload)]
                if not reflected_value:
                    return

                matches = self._get_matches(test_res, reflected_value)
                test_req = self._helpers.analyzeRequest(test_base)
                return CustomScanIssue(
                    test_base.getHttpService(),
                    test_req.getUrl(),
                    [self._callbacks.applyMarkers(test_base, None, matches)],
                    "XSS {}".format(attack_vector),
                    "Possible XSS Vector {} -> {}".format(attack_vector, self._helpers.bytesToString(reflected_value)),
                    "High")

            except Exception as e:
                print("[ErrCode 1] " + str(e))

            return

        # inject to referer
        header = "\n".join(headers)
        if 'referer: ' not in header.lower():
            # make referer and req
            test_req_raw = req_raw_str[:offset] + "\r\nReferer: " + xss_payload + req_raw_str[offset:]
            r = verify(test_req_raw, xss_payload, 'Referer 1')
            if r: yield r
        else:
            # edit referer and req
            for header in headers:
                if 'referer: ' in header.lower():
                    referer_value = header[len('referer: '):]
                    if referer_value in body: # referer reflected
                        idx = req_raw_str.index(header)
                        test_req_raw = req_raw_str[:idx+len(header)] + xss_payload + req_raw_str[idx+len(header):]
                        r = verify(test_req_raw, xss_payload, 'Referer 2')
                        if r: yield r
                        break

        # injecto to params
        for param in params:
            if param.getType() not in SUPPORT_PARAMETER_TYPES:
                continue

            decoded_value = self._helpers.urlDecode(param.getValue())
            if decoded_value in body: # parameter value was reflected
                start, end = param.getValueStart(), param.getValueEnd()

                payload = xss_payload
                if decoded_value.startswith('http'):
                    payload = 'javascript:alert(1)'
                    test_req_raw = req_raw_str[:start] + payload + req_raw_str[end:]
                else:
                    test_req_raw = req_raw_str[:end] + payload + req_raw_str[end:]

                print(test_req_raw)
                r = verify(test_req_raw, payload, param.getName())
                if r: yield r
                continue

        yield None
        '''
        print('-----S')
        print(body.encode('utf-8'))
        print('-----E')
        '''

    def doPassiveScan(self, baseRequestResponse):
        # look for matches of our passive check grep string
        iRI = self._helpers.analyzeRequest(baseRequestResponse)
        url = str(iRI.getUrl())
        params = iRI.getParameters()
        if not params:
            return

        print(url, iRI.getMethod())

        # params

        parameter_flag = True
        if iRI.getMethod() == "GET":
            for param in params:
                if param.getType() == IParameter.PARAM_URL:
                    parameter_flag = False
                    break
        elif iRI.getMethod() == "POST":
            for param in params:
                if param.getType() in SUPPORT_PARAMETER_TYPES:
                    parameter_flag = False
                    break

        if parameter_flag:
            return

        # headers
        issue = []
        headers = self._helpers.analyzeResponse(baseRequestResponse.getResponse()).getHeaders()
        for header in headers:
            if "content-type:" in header.lower():
                if "text/html" in header:
                    # print("Need XSS Check : " + url)
                    for result in self.checkXSS(baseRequestResponse, iRI.getHeaders(), params):
                        if not result:
                            continue
                        issue.append(result)

        return issue

        res = baseRequestResponse.getResponse()
        matches = self._get_matches(baseRequestResponse.getResponse(), GREP_STRING_BYTES)
        if (len(matches) == 0):
            return None

        # report the issue
        return [CustomScanIssue(
            baseRequestResponse.getHttpService(),
            self._helpers.analyzeRequest(baseRequestResponse).getUrl(),
            [self._callbacks.applyMarkers(baseRequestResponse, None, matches)],
            "CMS Info Leakage",
            "The response contains the string: " + GREP_STRING,
            "Information")]

    def doActiveScan(self, baseRequestResponse, insertionPoint):
        # make a request containing our injection test in the insertion point
        checkRequest = insertionPoint.buildRequest(INJ_TEST)
        checkRequestResponse = self._callbacks.makeHttpRequest(
                baseRequestResponse.getHttpService(), checkRequest)

        # look for matches of our active check grep string
        matches = self._get_matches(checkRequestResponse.getResponse(), INJ_ERROR_BYTES)
        if len(matches) == 0:
            return None

        # get the offsets of the payload within the request, for in-UI highlighting
        requestHighlights = [insertionPoint.getPayloadOffsets(INJ_TEST)]

        # report the issue
        return [CustomScanIssue(
            baseRequestResponse.getHttpService(),
            self._helpers.analyzeRequest(baseRequestResponse).getUrl(),
            [self._callbacks.applyMarkers(checkRequestResponse, requestHighlights, matches)],
            "Pipe injection",
            "Submitting a pipe character returned the string: " + INJ_ERROR,
            "High")]

    def consolidateDuplicateIssues(self, existingIssue, newIssue):
        # This method is called when multiple issues are reported for the same URL
        # path by the same extension-provided check. The value we return from this
        # method determines how/whether Burp consolidates the multiple issues
        # to prevent duplication
        #
        # Since the issue name is sufficient to identify our issues as different,
        # if both issues have the same name, only report the existing issue
        # otherwise report both issues
        if existingIssue.getIssueName() == newIssue.getIssueName():
            return -1

        return 0

#
# class implementing IScanIssue to hold our custom scan issue details
#
class CustomScanIssue (IScanIssue):
    def __init__(self, httpService, url, httpMessages, name, detail, severity):
        self._httpService = httpService
        self._url = url
        self._httpMessages = httpMessages
        self._name = name
        self._detail = detail
        self._severity = severity

    def getUrl(self):
        return self._url

    def getIssueName(self):
        return self._name

    def getIssueType(self):
        return 0

    def getSeverity(self):
        return self._severity

    def getConfidence(self):
        return "Certain"

    def getIssueBackground(self):
        pass

    def getRemediationBackground(self):
        pass

    def getIssueDetail(self):
        return self._detail

    def getRemediationDetail(self):
        pass

    def getHttpMessages(self):
        return self._httpMessages

    def getHttpService(self):
        return self._httpService
      
#####################################
##
##
