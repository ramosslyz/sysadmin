Postman vs Insomnia comparison
------------------------------

Postman | API Development Environment [https://www.getpostman.com](https://www.getpostman.com)  
Insomnia REST Client - [https://insomnia.rest/](https://insomnia.rest/)

| Features&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Insomnia  | Postman  | Notes |
| ------------- |:--------:|:-----:| -----|
| Create and send HTTP requests |   x   |  x  |   |
| Authorization header helpers    |   x   |  x  | Can create "Authorization" header for you for different authentication schemes: Basic, Digest, OAuth, Bearer Token, HAWK, AWS  |
| Maintains responses history per request  |   x   |  -  |  Whereas Postman maintains history for sent requests, responses are not organized per request, just mixed together in a single long list. Not too useful.  |
| Manages cookies like a web browser does    |   x    |  x   | Stores cookies obtained from "Set-Cookie" response header and sends them back in subsequent requests on per-domain basis. You can also manage cookies manually   |
| Use certificates for client authentication            |   x   |   x  |    |
| Generate code snippets          |   x    |   x  |  Can generate code snippets to send HTTP requests in various languages: curl, NodeJS, C#, Python, Ruby, raw HTTP protocol  |
| View raw HTTP traffic  |  x  |   0   | Whereas both tools show and parse responses, it's hard to see the actual request being sent. Insomnia provides access to raw HTTP traffic log through UI. With Postman, it's much trickier, you need to have Postman DevTools Console opened when making request.
| UI | xx | x | Insomnia has minimalistic, cute and simple UI. Postman UI is a bit overloaded and complicated for newcomer (maybe due to a bigger number of features). |
| Environment and variables |  x |  x |  Both tools have a notion of variable, and environment as a container for variables, which can be overriden by more specific environment (e.g. dev/stage/prod overrides global environment) |
| Organization |  x  |   x  | Both tools have a notion of a workspace to isolate different projects. Postman organize requests in collections and folders, whereas Insomnia uses folders only
| Request chaining |  x  |  xxx  | Both tools can pull response data of one request and feed it into the next request. But Postman is more powerful here. You can run all requests in a collection as a whole. You can write "before" and "after" request hooks in JavaScript with arbitrary logic. You can build simple sequential workflows consisting of several requests, that share some data with each other. You can have basic conditional logic. With Insomnia, you need to run requests one by one manually, and don't have a place to inject custom logic.
| API testing. Run tests/assertions against responses | - | x | With Postman, you can write tests/assertions against responses. Collection acts an executable description of an API. You can run all requests in the collection as a whole, and see test run results. Has CLI interface to run collections (newman). Can be used to automate API testing and integrate it into CI/CD workflow. |
| API Documentation | - |  `PREMIUM` |  Postman can generate documentation, that includes request description (Markdown), examples, code snippets (in various languages). Each request can have several examples (pairs of request-response payloads). Examples can be used to refine API protocol at design phase to show how endpoint works under different conditions (200, 4xx responses) |
| Mock server endpoint | - | `PREMIUM` | Postman can create mock of a server endpoint, based on request examples. Useful after design phase finished, so you can have frontend and backend teams work in parallel. |
| Data sync | `PREMIUM` |  x |  Postman syncs your data for free, whereas with Insomnia it's out of free tier.
| Team collaboration |  `PREMIUM` | `PREMIUM` |  |
| Built-in HTTP sniffer | - | x | Postman has a built in HTTP proxy sniffer, although it's very limited. It captures only requests without responses. In fact, it's not a full-blown sniffer for inspectation purposes. Instead, you can use it to bootstrap your project from the captured real-world requests, instead of crafting them manually. Supports only HTTP traffic. For HTTPS traffic self-signed certificate is used, which triggers warning in browser. Does not work if website has HTTPS+HSTS, because in this case you cannot bypass security warning in a browser |
| Import and Export | x | x | Postman supports: RAML, WADL, Swagger, curl. Insomnia supports: Postman v2, HAR, Curl.  |
| Other | - | - | Insomnia can craft GraphQL requests. Postman can craft SOAP requests.

Premium tier
============
Insomnia: $5-$8 per user/month. Includes: syncing, team collaboration.  
Postman: $10 per user/month. Includesteam collaboration, API documentation, mock servers, API monitoring, integrations.