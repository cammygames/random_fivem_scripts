# Installation
1. Add the items to qb-core/shared/items.lua
	```lua
		-- HexByte Tuning
		['tuning_advanced_laptop'] 				 = {['name'] = 'tuning_advanced_laptop', 			    	['label'] = 'Tuner Laptop', 				['weight'] = 2000, 		['type'] = 'item', 		['image'] = 'laptop.png', 			['unique'] = true, 		['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'With this laptop you can get your car on steroids or save it to a chip to sell to others.'},
		['tuning_chip_blank'] 				 = {['name'] = 'tuning_chip_blank', 			    	['label'] = 'Blank Tunerchip', 				['weight'] = 2000, 		['type'] = 'item', 		['image'] = 'tunerchip.png', 			['unique'] = false, 		['useable'] = false, 	['shouldClose'] = false,	   ['combinable'] = nil,   ['description'] = 'This is a blank tuner chip that has no data saved against it.'},
		['tuning_chip_written'] 				 = {['name'] = 'tuning_chip_written', 			    	['label'] = 'Written Tunerchip', 				['weight'] = 2000, 		['type'] = 'item', 		['image'] = 'tunerchip.png', 			['unique'] = true, 		['useable'] = true, 	['shouldClose'] = true,	   ['combinable'] = nil,   ['description'] = 'This chip contains a pre configured vehicle tune'},
	```
2. Add the following to qb-inventory/html/js/app.js in the FormatItemInfo function. I added it to mine before the else statment arround line 572. for people who use lj-inventory its arround line 629
	```js
		else if (itemData.name == "tuning_chip_written") {
			$(".item-info-title").html("<p>" + itemData.label + "</p>");
			$(".item-info-description").html("<p><strong>Tune Label:</strong>" + itemData.info.name +"</p>");
		} 
	```
3. Add the following to qb-garages/blob/main/client/main.lua at line 259
	```lua
		QBCore.Functions.TriggerCallback('hexbyte:tuning:server:GetVehicleTune', function(tune)
			exports['hexbyte_tuning']:SetVehicleTune(tune, veh)
		end, vehicle.plate)
	```
4. Run import.sql on your database
5. Add the following to your server config
	```
		ensure hexbyte_tuning
	```