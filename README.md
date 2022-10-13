# docker-ssl-monitor

Application to monitor certificates expiration.
Based on http://prefetch.net/code/ssl-cert-check, uses [hairlom-mailx](http://heirloom.sourceforge.net/mailx.html)
to send notifications.

Endpoints to be monitored can be given in a file /monitor-list:

```
# /monitor-list
domain.ext 443
domain2.ext 465
```

or via the `ENDPOINTS` environment variable.

The checks will run only once unless `CHECK_INTERVAL` or `DAILY_TIME` variables are set.


### Environment variables
| Variable | Mandatory | Default | Description |
|:--|:--|:-----------|:------------|
|`ENDPOINTS`|no|| Specifies the endpoints to monitor. A newline-separated list of `FQDN PORT`.| 
|`SEND_EMAIL`|no|| If set sends email notifications to the address specified in `SMTP_TO`.| 
|`SMTP_FROM`|no|`ssl-cert-check@localhost.localdomain`| `From:` address for notifications emails.| 
|`SMTP_USER`|no|| SMTP Username. <br>Required if `SEND_EMAIL` is set.| 
|`SMTP_PASS`|no|| SMTP Password. <br>Required if `SEND_EMAIL` is set.|
|`SMTP_URI`|no|| SMTP URI. Es: `smtps://mail.example.com:465"`. <br>Required if `SEND_EMAIL` is set.|
|`SMTP_TO`|no|| `To:` address for notifications emails. <br>Required if `SEND_EMAIL` is set.|
|`WARNING_DAYS_MAX`|no|`30`|Maximum remaining days of certificate validity before notification.|
|`WARNING_DAYS_MIN`|no|`-1`|Minimum remaining days of certificate validity before notification.|
|`CHECK_INTERVAL`|no||Duration (in seconds) of sleep between checks.|
|`DAILY_TIME`|no||If set run the script daily at the specified time (UTC). Examples: `14:00`, `23:59:59`|
|`WEEKLY_TIME`|no||If set run the script weekly at the specified time (UTC). Example: `"Thursday 23:00:00"`|
|`CHAT_API`|no||HTTPS address of Discord or Slack (untested, maybe in the future) chatroom APIs. Will send full report to this chatroom.|