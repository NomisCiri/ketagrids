# Grids - Web Version
Web based version of Kids with Grids

## Host the app on a web server
Host the app on a web server so that it is publicly accessible from a URL.

## Launching the app
When redirecting the participant to the app you cann pass the following URL parameters in order to skip the registration page:

- **condition**: 0 is *smooth*, 1 is *rough*
- **uid**: participant ID
- **age**: participant age
- **grade**: participant grade

For example you can redirect the participant to the experiment by generating a URL like the following:

*http://APP-URL-ON-YOUR-SERVER.com/index.html?uid=1234&condition=1&age=33&gender=male*


## Posting the experiment data to a server
When the participant finishes the experiment, the app posts the session data to the server specified at the beginiing of the `js/isrc-utils.js` file:

```js
/**
 * URL of server where to post the data at the end of the experiment
 */
serverURI: "https://INSERT-SERVER-URL-HERE",
```

You need to create a server side script (for example a php script) that receives the data and saves it to a database.
The data is passed using HTTP POST as a string in the the 'data' parameter.

Example PHP script:
```php
<?php 
    $data = json_decode($_POST['data']);
    $participant_id = $data['uid'];

    // Save data to a database...
?>
```

## Number of rounds
To change the number of rounds (included the bonus round) you can change the following variable in `js/gridSearch.js`:

```js
totalTrialsNumber = 6, // includes the instructions trial and the bonus trial
```

*Note: there are some hardcoded references to the number of rounds in the text.*