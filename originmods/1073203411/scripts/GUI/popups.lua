local PopupDialogScreen		= require "screens/popupdialog"

function CreateChoicePopup(title,body,action_yes,action_no)
	
	local choices = { 
		{ 
		  		text = "OK", 
				cb = function()
				TheFrontEnd:PopScreen()
				action_yes()
			end
		}
	}
	
	if action_no then
		table.insert(choices,
		{ 
		  		text = "Cancel", 
				cb = function()
				TheFrontEnd:PopScreen()
				action_no()
			end
		}
		)
	end
	
	TheFrontEnd:PushScreen(
		PopupDialogScreen( title, body, choices)
	)
	
end

function CreateProcessPopup(title,body,process,postexec_process)
	
	TheFrontEnd:PushScreen(
		PopupDialogScreen( title, body, { 
		  		text = "Please wait", 
				cb = function()
			end
		})
	)

	TheWorld:DoTaskInTime(0.1,
	function()
	
		process()
	
		TheFrontEnd:PopScreen()
		
		postexec_process()
	end)
end

function CreateErrorPopup(error_string)
	TheSim:SetTimeScale(0)
	local abort = function() TheSim:ForceAbort() end
	CreateChoicePopup("Error",error_string,abort,nil)
end

return {
	["CreateProcessPopup"] = CreateProcessPopup,
	["CreateChoicePopup"] = CreateChoicePopup ,
	["CreateErrorPopup"] = CreateErrorPopup 
}