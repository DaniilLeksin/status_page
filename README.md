# Status Page Puller

### Project statement:

> *Create a command-line tool to pull status information from different services, displays the results and saves it into a data store.*

### Constraints:

- Minimize **gem** usage
- Avoid using **SQL** or **NoSQL** database
- Easy to understand and extend
- Own code


### Action List:
0. Implementation (UPDATED)
1. Preparations
2. Handling responses
3. I/O
4. Modes: **PULL/LIVE/HISTORY/backup/restore** + 2 extra
5. UI/UX
6. Specs
7. Time estimations 

##

### 0. Implementation

- **0.1 Bundles:** to install required gems run

`bundle install`

- **0.2 Script commands:** to show the script commands, run:

`./bin/status-page.rb help`

```
Commands:
  status-page.rb backup <path>             # [STUB:IN_PROGRESS]Merge History into one file
  status-page.rb help [COMMAND]            # Describe available commands or one specific command
  status-page.rb history [PATH] [VERBOSE]  # Display all data
  status-page.rb live [TIMEOUT][PATH]      # Non Stop periodically Request Services
  status-page.rb pull [PATH]               # Request Services and save response into file.
  status-page.rb restore <path>            # [STUB:IN_PROGRESS]Restore backup file
```

-- **PULL mode usage:** `./bin/status-page.rb help pull`:

```
Usage:
  status-page.rb pull [PATH]

Options:
  [--path=PATH]  # Save result in the specified file.

Description:
  
  `status_page pull` will request services from the list and save result to file. You can optionally specify parameter [PATH], which will set the file to save results. If [PATH] is NOT specified, the 
  `status_page` script will automatically creates the output folder (the path to output folder is defined in configuration file) and store response data into it. The script uses Unix Time Timestamp as 
  a name of the files.
```

-- **LIVE mode usage:** `./bin/status-page.rb help live`:

```
Usage:
  status-page.rb live [TIMEOUT][PATH]

Options:
  [--timeout=N]  # Set timeout between the requests (in seconds).
                 # Default: 1
  [--path=PATH]  # Save result in the specified file.

Description:
  
  `status_page live` will periodically requests services from the list and save results into the files (every request generates separate file with response). You can optionally specify parameter 
  [TIMEOUT], which will set timeout before the requests. By DEFAULT [TIMEOUT] parameter is set to 1 second. Parameter [PATH] specifies the file to save responses. If [PATH] is specified all response 
  data will be saved into this file. If this parameter is NOT specified, the script automatically saves results into the file in output folder (the path to output folder is defined in configuration 
  file). !!!===To STOP the process please use `Ctrl+c`==!!! It will safely mange last response and exit.
```
**IMPORTANT NOTE** To STOP the process please use `Ctrl+c`

-- **HISTORY mode usage:** `./bin/status-page.rb help history`:

```
Usage:
  status-page.rb history [PATH] [VERBOSE]

Options:
  [--path=PATH]                # Save result in the specified file.
  [--verbose], [--no-verbose]  # Set verbose mode.
                               # Default: true

Description:
  
  `status_page history` will merge all response data collected in output_folder (path to output folder is defined in configuration file) into one history file (path to history folder is defined in 
  configuration file). If [PATH] parameter is specified merged data will be stored in this file. Parameter [VERBOSE] defines the output merged data into user terminal. It accepts to values: 
  `--verbose`/`--no-verbose`. If set `--verbose` key, history files will be shown in terminal and vice versa, if `--no-verbose` key is set, display output is disabled. By DEFAULT [VERBOSE] is set to 
  `--verbose`. All data will be displayed. All collected response files will be moved into the trash_folder (the path to trash folder is defined in configuration file).
```

-- **BACKUP/RESTORE modes usage** Not implemented. Stubbed.
```
[STUB:IN_PROGRESS]Restore backup file
[STUB:IN_PROGRESS]Merge History into one file
```

- **0.3 Tests:** To run specs:

`rake rspec`
Not all tests are implemented.

- **0.4 Input data:**

**CONFIGURATION file:** is a file to store configuration values/parameters. Configuration file is a YAML file with the name `configuration.yml`. It is stored in project root directory.

```
---
:timestamp: '1536565255'
:configuration:
  :service_list: data/services.csv
  :output_folder: output/
  :history_folder: output/history/
  :trash_folder: output/trash/
  :backup_folder: output/backup/
  :last_updated: ''
  :error_output: ''
  :fill: false
  :max_size: 1
```
*Descriptions:*

- `timestamp`: timestamp of the last update in the configuration file
- `service_list`: path to service.csv file with list of services to check
- `output_folder`: path to all result directories/files
- `history_folder`: path to store file for `HISTORY` mode
- `trash_folder`: path to store already processed files
- `backup_folder`: FFU
- `last_updated`: FFU
- `error_output`: FFU
- `fill`: FFU
- `max_size`: Max size of any output file in MB.

**SERVICE LIST FILE:**
All service data is stored as `CSV` file.

```
Atlassian Bitbucket,https://bqlf8qjztdtr.statuspage.io/api/v2/status.json,[none=up;minor=minor;major=major;critical=critical],indicator,updated_at
Cloudflare,https://yh6f0r4529hb.statuspage.io/api/v2/status.json,[none=up;minor=minor;major=major;critical=critical],indicator,updated_at
RubyGems.org,https://pclby00q90vc.statuspage.io/api/v2/status.json,[none=up;minor=minor;major=major;critical=critical],indicator,updated_at
GitHub,https://status.github.com/api/status.json,[good=up;minor=minor;major=major],status,last_updated
Heroku,https://status.heroku.com/api/v3/current-status,[green=up;yellow=yellow;red=red],Production,NONE
```

`services.csv` is flexible, you can modify options.

*Example:*
`Atlassian Bitbucket,https://bqlf8qjztdtr.statuspage.io/api/v2/status.json [none=up;minor=minor;major=major;critical=critical],indicator,updated_at`

*File structure:*
`|Service Name|API_ENDPOINT|RULES|KEYS|`

- `Service Name`: service file name
- `API_ENDPOINT`: Endpoint to request statis API
- `RULES`: (flexible). Service can provide different different status messages (e.g. NONE/GREEN/GOOD). To result in one way, you can specified the rule to change response values.

*Rule Example:*
```
[none=up;minor=minor;major=major;critical=critical]
```
 - means, that if service responses with `status=None`, the RULE will transform it to `UP`

Therefore it is a flexible way to collect statuses `the things in style`.

- `Last values` - values after the RULE - is strings with key names from the service response.

**Example:** Github status responses with:
```json
{
  "status": "good",
  "last_updated": "2012-12-07T18:11:55Z"
}
```

**Keys:** `status,last_updated`

**Example:** RubyGems status responses with:

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
**Keys:** `indicator,updated_at`

**Example:** Heroky status responses with:

```json
{
	"status":{
    	"Production":"green",
        "Development":"green"
    },
    "issues":[]
}
```

**Keys:** `Development,None`

**IMPORTANT_NOTE:** First `TWO` keys have to be `STATUS`,`UPDATED_AT` values. If response doesn't provide any of them fill the string with `NONE`.

**IMPORTANT_NOTE**: Algorithm is serarching for key in `KEYS` recursively, no NEED to set full keymap (eg. `page.indicator`)


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
    storeHistory();
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

### 6. Specs
> *approx. 4 hours*

`Test cases:`

- I/O cases: Testing Input Components/Testing Output Components/File doesn't exists/Reach MAX file size/Overwrite file/Different OS
- Handling responses: Success/Failed responses. Bad urls. 
- Modes: PULL/LIVE/HISTORY/backup/restore
- UI/UX - skipped as not non-priority

### 7. Time Estimations

Time estimation: 28 hours. (Optimistic)
