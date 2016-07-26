---
post_title: Examples
nav_title: Examples
menu_order: 20
---

# A Simple Job

```json
{
  "id": "my-job",
  "description": "A job that sleeps",
  "run": {
    "cmd": "sleep 1000",
    "cpus": 0.01,
    "mem": 32,
    "disk": 0
  }
}
```

# A Job with a Schedule

{
  "id": "my-scheduled-job",
  "description": "A job that sleeps on a schedule",
  "run": {
    "cmd": "sleep 20000",
    "cpus": 0.01,
    "mem": 32,
    "disk": 0
  },
  "schedules": [
    {
      "id": "sleep-nightly",
      "enabled": true,
      "cron": "20 0 * * *",
      "concurrencyPolicy": "ALLOW"
    }
  ]
}