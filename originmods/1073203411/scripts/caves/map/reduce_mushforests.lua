
-- Reduce mush forests size
AddTaskPreInit("RedForest", function(task)
task.room_choices.RedMushForest = 1
task.room_choices.PitRoom = 1
end)
AddTaskPreInit("GreenForest", function(task)
task.room_choices.GreenMushForest = 1
task.room_choices.PitRoom = 1
end)
AddTaskPreInit("BlueForest", function(task)
task.room_choices.BlueMushForest = 1
task.room_choices.BlueMushMeadow = 1
task.room_choices.PitRoom = 1
end)