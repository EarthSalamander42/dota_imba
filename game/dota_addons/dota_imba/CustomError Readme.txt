# CustomError

[Preview](http://puu.sh/b6gXN/112b20d2ac.webm)

###### Usage

* Put the files in their correct folders
* In Lua, use FireGameEvent( 'custom_error_show', { player_ID = pID, _error = "Type Your Error Here" } )

###### custom_events.txt

```
"CustomEvents"
{
	"custom_error_show"
	{
		"player_ID"		"short"
		"_error"		"string"
	}
}
```

