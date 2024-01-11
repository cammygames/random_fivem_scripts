# HexByte Docks

---
## Installation
1. Add the following to qb-core/shared/jobs.lua
```
['dockworker'] = {
    label = 'Dock Worker',
    defaultDuty = true,
    offDutyPay = false,
    grades = {
        ['0'] = {
            name = 'Driver',
            payment = 50
        },
    },
}
```

2. Add the following to qb-cityhall/config.lua
```
["dockworker"] = {["label"] = "Dock Worker", ["isManaged"] = false}
```

3. ensure the resources in your server.cfg