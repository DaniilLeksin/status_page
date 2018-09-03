# Status Page Puller

### Project statement:

> *Create a command-line tool to pull status information from different services, displays the results and saves it into a data store.*

### Constraints:

- Minimize **gem** usage
- Avoid using **SQL** or **NoSQL** database
- Easy to understand and extend
- Own code


### Action List:

1. Preparations
2. Handling responses
3. I/O
4. Modes: **PULL/LIVE/HISTORY/backup/restore** + 2 extra
5. UI/UX
6. Time estimations 

##

### 1. Preparations
> *approx. 4 hours*

Study the task. Prepare Project Plan.

### 2. Handling responses
> *approx. 6 hours*

Prepare test list for online services. Analyze services **API/ENDPOINTS/response structures**. Implement Unit tests. Structure request input.

4 services:

1. [https://status.bitbucket.org/]()
2. [https://www.cloudflarestatus.com/]()
3. [https://status.rubygems.org/]()
4. [https://status.github.com/messages]()


- **2.1 Bitbucket Status API** from [BitBucket API Docs](https://status.bitbucket.org/api#status)

	**Name:** `Atlassian Bitbucket`
    
	**Endpoint:** [https://bqlf8qjztdtr.statuspage.io/api/v2/status.json]()
    
    **Response:** 
```json
{
  "page":{
    "id":"bqlf8qjztdtr",
    "name":"Atlassian Bitbucket",
    "url":"https://status.bitbucket.org",
    "updated_at": "2018-08-29T09:33:34Z"
  },
  "status": {
    "description": "Partial System Outage",
    "indicator": "major"
  }
}
```
- **2.2 Cloudflare System Status** from [Cloudflare Status API](https://www.cloudflarestatus.com/api)

	**Name:** `Cloudflare `
    
	**Endpoint:** [https://yh6f0r4529hb.statuspage.io/api/v2/status.json]()
    
    **Response:** 
```json
{
  "page":{
    "id":"yh6f0r4529hb",
    "name":"Cloudflare",
    "url":"https://www.cloudflarestatus.com",
    "updated_at": "2018-08-29T09:37:27Z"
  },
  "status": {
    "description": "Partial System Outage",
    "indicator": "major"
  }
}
```
- **2.3 RubyGems.org Status** from [RubyGems.org Status API](https://status.rubygems.org/api#status)

	**Name:** `RubyGems.org `
    
	**Endpoint:** [https://pclby00q90vc.statuspage.io/api/v2/status.json]()
    
    **Response:** 
```json
{
  "page":{
    "id":"pclby00q90vc",
    "name":"RubyGems.org",
    "url":"https://status.rubygems.org",
    "updated_at": "2018-08-29T09:39:08Z"
  },
  "status": {
    "description": "Partial System Outage",
    "indicator": "major"
  }
}
```
- **2.4 GitHubStatus** from [GitHubStatus API](https://status.github.com/api)

	**Name:** `????????`
    
	**Endpoint:** [https://status.github.com/api/status.json]()
    
    **Response:** 
```json
{
  "status": "good",
  "last_updated": "2012-12-07T18:11:55Z"
}
```

##

`Difficulties:`
- 3 of 4 have the same JSON response structure. Assume that JSON responses from different status pages are not unified. Need to find universal algorithm to process response data.

##

One more service to see the difference:

- **2.5 Heroku Status:** from [Heroku Dev Center](https://status.heroku.com)

**Endpoint:** [https://status.heroku.com/api/v3/current-status]()


```json
{
	"status":{
    	"Production":"green",
        "Development":"green"
    },
    "issues":[]
}
```

`Features:` 
- Some services provide status information about internal microservices or/and components. It's a possible option to monitor them too.
- Fast and straight way to gain services statuses is to wrap [https://statuspages.me/]() but I'm sure it is the goal of the task.


### 3. I/O
> *approx. 4 hours*

Analyze cross platform solutions to store Data (pros and cons of **JSON/YAML/CSV** .. etc). Implement **Read/Write/Update** functions. Exceptions handling. Prepare test cases and test data. Testing.

`Features:`
- Specify measures, data collection and storage Procedures
- Implement `configuration.file` to store script settings. (PATHS/VALUES)
- Implement file MAX size, rewrite partially chunk by chunk after reaching MAX file size. (Set default value in `configuration.file`).
- All output files are marked with **timestamp** value
- Store error messages
- Multioptional user Input. `--configure` commands. `--run` - request service(s) single/list/from file.


### 4. Implementation of 3 + 2 modes
> *approx. 6 hours*

- 4.1 `status-page.rb pull: PULL`
```ruby
begin
    # 1. load PATHS to input data. (I/O)
    if CONF_FILE exists? THEN loadConfigurationData();
    # 2. prepare services request data. (I/O)
    getRequestData();
    # 3. query GET request. (Handling responses)
    sendRequest();
    # 4. parse response. (Handling responses)
    parseResponse();
    # 5. store resonse data to a file. (I/O)
    storeResponseData();
    # 6. user output. (UI/UX)
    showResults();
rescue
    types_of_exceptions;
end;

```
loadConfigurationData
- 4.2 `status-page.rb live: LIVE`
```ruby
begin
    # 1. load PATHS to input data. (I/O)
    if CONF_FILE exists? THEN loadConfigurationData();
    # 2. periodically call Pull mode
    loop(PARAMS)
        # call pull mode
        callPullMode();
    end;
rescue
    types_of_exceptions;
end;
```
- 4.3 `status-page.rb history: HISTORY`
```ruby
begin
    # 1. load PATHS to input data. (I/O)
    if CONF_FILE exists? THEN loadConfigurationData();
    # 2. load file history (I/O)
    loadHistory();
rescue
    types_of_exceptions;
end;

```
- 4.4 `status-page.rb backup <path> : BACKUP`
```ruby
begin
    # 1. load PATHS to input data. (I/O)
    if CONF_FILE exists? THEN loadConfigurationData();
    # 2. store file history (I/O)
    storeResponseData (PATH);
rescue
    types_of_exceptions;
end;
```
`Feature:` Make it automatic (day/number_of_requests/file_size)
- 4.5 `status-page.rb restore <path> : RESTORE`
```ruby
begin
    # 1. load PATHS to input data. (I/O)
    if CONF_FILE exists? THEN loadConfigurationData();
    # 2. load file history (I/O)
    loadResponseData (PATH);
rescue
    types_of_exceptions;
end;
```

`Features:`
- Try to code with **KISS** and **DRY** principles.
- Collect measures data. Main is **Response Time**.
- Handle unreachable services.
- Request repeatedly after timeout. If 5xx Errors.
 


### 5. UX
> *approx. 4 hours*

Use [Thor](http://whatisthor.com) for CLI. Design Data output format.

`Features:`
- full-featured help
- editing `conficuration.file` from CLI

Script call examples:
- **5.0** `default 5 modes`
```
./status-page pull
```
```
./status-page live
```
```
./status-page history
```
```
./status-page backup PARAM # PARAM: path to backup file
```
```
./status-page restore PARAM # PARAM: path to backup file
```
- **5.1** `--configure PARAMS` in the process of thinking
```
./status-page --configure PATH # PATH: open in nano/notepad configuration.file
```
- **5.2** `--run PARAMS`
```ruby
./status-page --run [-p PATH][-s URL][-l URL_LIST]
# PATH: path to the file with services data (by default script will try to get path to service list from configuration.file)
# URL: reqest single service
# URL_LIST: comma separated list of services
```

### 6. Time Estimations

Time estimation: 24 hours. (Optimistic)
