--[[
   __     __     __    __     ______     ______   ______     ______    
  /\ \   /\ \   /\ "-./  \   /\  ___\   /\__  _\ /\  ___\   /\  == \   
 _\_\ \  \ \ \  \ \ \-./\ \  \ \___  \  \/_/\ \/ \ \  __\   \ \  __<   
/\_____\  \ \_\  \ \_\ \ \_\  \/\_____\    \ \_\  \ \_____\  \ \_\ \_\ 
\/_____/   \/_/   \/_/  \/_/   \/_____/     \/_/   \/_____/   \/_/ /_/ 
                                                                                                                                                                 
]]

--						[	~INFORMATION~      ] 
local calculator = script
local version = "version 3.2.6 PEACH"

local keycodes = {
	Primary = {
		["0"] = Enum.KeyCode.Zero,
		["1"] = Enum.KeyCode.One,
		["2"] = Enum.KeyCode.Two,
		["3"] = Enum.KeyCode.Three,
		["4"] = Enum.KeyCode.Four,
		["5"] = Enum.KeyCode.Five,
		["6"] = Enum.KeyCode.Six,
		["7"] = Enum.KeyCode.Seven,
		["8"] = Enum.KeyCode.Eight,
		["9"] = Enum.KeyCode.Nine,
		["."] = Enum.KeyCode.Period,
		["Add"] = Enum.KeyCode.Equals,
		["Subtract"] = Enum.KeyCode.Minus,
		["Multiply"] = Enum.KeyCode.X,
		["Divide"] = Enum.KeyCode.Slash,
		["Clear"] = Enum.KeyCode.Space,
		["FtD"] = Enum.KeyCode.F,
		["Backspace"] = Enum.KeyCode.Backspace,
		["Enter"] = Enum.KeyCode.Return,
	},
	Secondary = {
		["0"] = Enum.KeyCode.Zero,
		["1"] = Enum.KeyCode.KeypadOne,
		["2"] = Enum.KeyCode.KeypadTwo,
		["3"] = Enum.KeyCode.KeypadThree,
		["4"] = Enum.KeyCode.KeypadFour,
		["5"] = Enum.KeyCode.KeypadFive,
		["6"] = Enum.KeyCode.KeypadSix,
		["7"] = Enum.KeyCode.KeypadSeven,
		["8"] = Enum.KeyCode.KeypadEight,
		["9"] = Enum.KeyCode.KeypadNine,
		["."] = Enum.KeyCode.KeypadPeriod,
		["Add"] = Enum.KeyCode.KeypadPlus,
		["Subtract"] = Enum.KeyCode.KeypadMinus,
		["Multiply"] = Enum.KeyCode.KeypadMultiply,
		["Divide"] = Enum.KeyCode.KeypadDivide,
		["Clear"] = Enum.KeyCode.Clear,
		["FtD"] = Enum.KeyCode.J,
		["Backspace"] = Enum.KeyCode.Undo,
		["Enter"] = Enum.KeyCode.KeypadEnter,
	},
	
	Toggle = Enum.KeyCode.LeftControl
}






--						[	~VARIABLES~      ] 

local d = script.Parent.Parent

local variable1 = "0"
local variable2 = "0"
local answer = "0"
local num = "Unselected"
local curVariable = 1


--						[	~TABLES~      ] 

local history = {}





--						[	~CALCULATOR FUNCTIONS~      ] 

function WriteVariable(writeTo, write) --Write Variable
	if writeTo==1 then 
		if variable1 == "0" and not (variable1 == "0.") and not (write == ".") then 
			variable1 = ""
		end
		variable1 = variable1 .. write
		d.UI.Display.Text = variable1
	end
	if writeTo==2 then 
		if variable2 == "0" and not (variable2 == "0.") and not (write == ".") then 
			variable2 = ""
		end
		variable2 = variable2 .. write
		d.UI.Display.Text = variable2
	end
	if writeTo==-1 then 
		num = write
		d.UI.Function.Text = GetSign(write)
	end
	if writeTo==3 then 
		variable1 = "0"
		variable1 = variable1 .. write
		d.UI.Display.Text = variable1
	end
end


function FindNextNumber(tablex, property, c) --Find the max property number in a table
	local number = 0
	for _,v in pairs(tablex) do 
		if (c==nil or v:IsA(c)) and v[property]>number then 
			number = v[property]
		end
	end
	return number
end

function customFindNextNumber(t) --For the history function, Finds the lowest name number in the table.
	local number = 51
	for _, v in pairs(t) do 
		if v:IsA("Frame") and tonumber(v.Name)  then
			if tonumber(v.Name)<=number then 
				number = tonumber(v.Name)
			end
		end
	end
	return number-1
end

function OutputWarn(error)	--Writes an error with a title mark.
	warn("Calculator" .. version .. "\n\t" .. error)
end

function GetSign(solving) --Finds the correct sign based on the operation
	if solving == "add" or solving == "+" then 
		return "+"
	end
	if solving == "subtract" or solving == "-" or solving == "sub" then 
		return "-"
	end
	if solving == "multiply" or solving == "x" or solving == "*" or solving == "×" then 
		return "×"
	end
	if solving == "divide" or solving == "/" then 
		return "÷"
	end
	if solving == "sq" then 
		return "²"
	end
	if solving == "sqrt" then 
		return "√"
	end

	return "" 
end

function WriteHistory(problemToWrite) --Writes the history based on a problem
	table.insert(history, problemToWrite)
	local nh = d.Examples.historyUIExample:Clone()
	nh.Name = "50"
	nh.Visible = true
	nh.Name = customFindNextNumber(d.UI.History:GetChildren()) 
	nh.Parent = d.UI.History
	nh.pos.Problem.Text = problemToWrite[1] .. " ".. problemToWrite[3] .. " ".. problemToWrite[2]
	nh.pos.Answer.Text = problemToWrite[4]
	nh.pos.Date.Text = problemToWrite[5]
end

function Solve(variable_1, variable_2, solving) --Solves a problem based on the variables and problem


	if string.find(tostring(variable_1), "/") then 
		local a = string.split(tostring(variable_1), "/")
		variable_1 = a[1]/a[2]
	end
	if string.find(tostring(variable_2), "/") then 
		local a = string.split(tostring(variable_2), "/")
		variable_2 = a[1]/a[2]
	end													--These 4 statements convert the fractions to decimals.
	if string.find(tostring(variable1), "/") then 
		local a = string.split(tostring(variable1), "/")
		variable1 = a[1]/a[2]
	end
	if string.find(tostring(variable2), "/") then 
		local a = string.split(tostring(variable2), "/")
		variable2 = a[1]/a[2]
	end


	local answer = 0
	if variable1 == "" or variable1 == nil then 
		variable1 = "0"
	end
	if variable2 == "" or variable2 == nil then 
		variable2 = "0"
	end
	if solving == "add" or solving == "+" then 
		answer = tonumber(variable1)+tonumber(variable2)
	end
	if solving == "subtract" or solving == "-" or solving == "sub" then 
		answer =  tonumber(variable1)-tonumber(variable2)
	end
	if solving == "multiply" or solving == "x" or solving == "*" or solving == "×" then 
		answer =  tonumber(variable1)*tonumber(variable2)
	end
	if solving == "divide" or solving == "/" then 
		answer =  tonumber(variable1)/tonumber(variable2)
	end
	if solving == "sq" then 
		if curVariable == 1 then 
			answer = variable_1*variable_1
			variable_2 = ""
		elseif curVariable == 2 then 
			variable1 = variable_2 
			variable2 = ""
			answer = variable_1*variable_1
			variable_2 = ""
		elseif curVariable == 3 then 
			answer = variable_1*variable_1
			variable_2 = ""
		end
	end
	if solving == "sqrt" then 
		if curVariable == 1 then 
			answer = math.sqrt(variable_1)
			variable_2 = ""
		elseif curVariable == 2 then 
			variable1 = variable_2 
			variable2 = ""
			answer = math.sqrt(variable_1)
			variable_2 = ""
		elseif curVariable == 3 then 
			answer = math.sqrt(variable_1)
			variable_2 = ""
		end
	end
	if solving == "Unselected" then 
		answer =  variable_1
	end

	if GetSign(solving) == nil and variable2 == "0" then
		WriteHistory({variable1, "1", "×", answer, (os.date("%B") .. " " .. os.date("%d") .." " .. os.date("%I") .. ":" .. os.date("%M"))})
	else 
		WriteHistory({variable1, variable2, GetSign(solving), answer, (os.date("%B") .. " " .. os.date("%d") .." " .. os.date("%I") .. ":" .. os.date("%M"))})
	end
	return answer
end

function decimalToFraction(decimal)	--Do I need to explain this
	local function gcd(a, b)
		while b ~= 0 do
			a, b = b, a % b
		end
		return a
	end

	local numerator = decimal
	local denominator = 1

	local limit = 1000000
	while decimal % 1 ~= 0 and denominator <= limit do
		decimal = decimal * 10
		numerator = decimal
		denominator = denominator * 10
	end

	local gcdValue = gcd(numerator, denominator)
	numerator = numerator / gcdValue
	denominator = denominator / gcdValue

	return numerator, denominator
end



--						[	~USER INPUT FUNCTIONALITY FUNCTIONS  ~      ] 



function clear() --clears the variables
	d.TweeningUIElements.Clear.Visible = true
	d.TweeningUIElements.Clear.Size = UDim2.new(0, 1, 0, 1)
	d.TweeningUIElements.Clear.BackgroundTransparency = 0
	game:GetService("TweenService"):Create(d.TweeningUIElements.Clear, TweenInfo.new(0.3), {Size = UDim2.new(0, 1500, 0, 1500)}):Play()
	wait(0.2)
	variable1 = "0"
	variable2 = "0"
	answer = "0"
	num = "Unselected"
	d.UI.Display.Text = "0"
	curVariable = 1
	d.UI.Function.Text = ""
	game:GetService("TweenService"):Create(d.TweeningUIElements.Clear, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
	wait(0.3)
	d.TweeningUIElements.Clear.Visible = false
	d.TweeningUIElements.Clear.Size = UDim2.new(0, 1, 0, 1)
	d.TweeningUIElements.Clear.BackgroundTransparency = 0
end

function clearEntry() --Clears just the current entry
	d.TweeningUIElements.ClearEntry.Visible = true
	d.TweeningUIElements.ClearEntry.Position = UDim2.new(1.5, 0,0.146, 0)
	d.TweeningUIElements.ClearEntry.BackgroundTransparency = 0
	game:GetService("TweenService"):Create(d.TweeningUIElements.ClearEntry, TweenInfo.new(0.3), {Position = UDim2.new(0.5, 0,0.146, 0)}):Play()
	wait(0.2)
	if curVariable == 1 then 
		variable1 = "0"
		d.UI.Display.Text = variable1
		curVariable = 1
	end
	if curVariable == 2 then 
		variable2 = "0"
		d.UI.Display.Text = variable2
		curVariable = 1
	end
	if curVariable == -1 then 
		num = "Unselected"
		d.UI.Display.Text = variable1
		curVariable = -1
	end
	if curVariable == 3 then 
		variable1 = "0"
		variable2 = "0"
		answer = "0"
		num = "Unselected"
		d.UI.Display.Text = "0"
		curVariable = 1
	end
	wait(0.05)
	game:GetService("TweenService"):Create(d.TweeningUIElements.ClearEntry, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
	wait(0.3)
	d.TweeningUIElements.ClearEntry.Visible = false
	d.TweeningUIElements.ClearEntry.Position = UDim2.new(1.5, 0,0.146, 0)
	d.TweeningUIElements.ClearEntry.BackgroundTransparency = 0
end

function backspace() --functionality for the erase function
	if curVariable == 1 then 
		variable1 = variable1:sub(1, variable1:len()-1)
		d.UI.Display.Text = variable1
	end
	if curVariable == 2 then 
		variable2 = variable2:sub(1, variable2:len()-1)
		d.UI.Display.Text = variable2
	end
	if curVariable == -1 then 
		num = "Unselected"
		d.UI.Function.Text = ""
	end

	if d.UI.Display.Text == "" then 
		d.UI.Display.Text = "0"
	end
end

function clearHistory() --Clears the history
	for _, v in pairs(d.UI.History:GetChildren()) do 
		if v:IsA("Frame") then 
			for _, x in pairs(v:GetDescendants()) do 
				if x:IsA("TextLabel") then 
					game:GetService("TweenService"):Create(x, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
				end
				if x:IsA("Frame") then 
					game:GetService("TweenService"):Create(x, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
				end
				if x:IsA("UIStroke") then 
					game:GetService("TweenService"):Create(x, TweenInfo.new(0.3), {Transparency = 1}):Play()
				end
			end
			game:GetService("TweenService"):Create(v.pos, TweenInfo.new(0.3), {Position = UDim2.new(0.75, 0,0.5, 0)}):Play()
			wait(0.3)
			v:Destroy()
		end
	end

	local length = #history
	while length > 0 do
		table.remove(history, length)
		length = length - 1
	end
end

function AskToClear()
	if not (d.UI.clear.Text == "Cancel") then 
		d.UI.clear.Text = "Cancel"
		d.UI.confirm.Visible = true
		d.UI.confirm.MouseButton1Down:Connect(function()
			if d.UI.clear.Text == "Cancel"  then 
				d.UI.clear.Text = "Clear"
				d.UI.confirm.Visible = false
				clearHistory()
			end
		end)
		game.UserInputService.InputBegan:Connect(function(kc)
			if kc.KeyCode == Enum.KeyCode.Escape and d.UI.clear.Text == "Cancel" then 
				d.UI.clear.Text = "Clear"
				d.UI.confirm.Visible = false
			end
		end)
	elseif d.UI.clear.Text == "Cancel" then 
		d.UI.clear.Text = "Clear"
		d.UI.confirm.Visible = false
	end
end

function writeNumber(write) -- adds a number based on the user's input
	if curVariable == 1 then 
		WriteVariable(1, tostring(write))
	end
	if curVariable == 2 then 
		WriteVariable(2, tostring(write))
	end
	if curVariable == -1 then 
		WriteVariable(2, tostring(write))
	end
	if curVariable ==3 then 
		curVariable = 1 
		WriteVariable(1, tostring(write))
	end
end

function writeDecimal() --Writes a decimal based on the user's input
	local write = "."
	if curVariable == 1 then 
		WriteVariable(1, tostring(write))
	end
	if curVariable == 2 then 
		WriteVariable(2, tostring(write))
	end
	if curVariable == -1 then 
		WriteVariable(2, tostring(write))
	end
	if curVariable ==3 then 
		curVariable = 1 
		variable1 = "0"
		variable2 = ""
		WriteVariable(3, tostring(write))
	end
end

function Negate() --Makes a number negative or positive
	if curVariable == 1 then 
		variable1 = variable1*-1
		d.UI.Display.Text = variable1
	end
	if curVariable == 2 then 
		variable2 = variable2*-1
		d.UI.Display.Text = variable2
	end
	if curVariable == -1 then 
		variable1 = variable1*-1
		d.UI.Display.Text = variable1
	end
	if curVariable == 3 then 
		variable1 = variable1*-1
		d.UI.Display.Text = variable1
	end
end

function Submit() --Basically the = sign. Just solves the problem and clears the inputs
	local x =  Solve(variable1, variable2, num)
	d.UI.Display.Text = x
	answer = x
	variable1 = x
	variable2 = "0"
	d.UI.Function.Text = ""
	num = "Unselected"
	curVariable = 3 
end

function writeOperation(operation) --Based on the users input, sets the operation (+, -, *, /)
	curVariable = 2 
	WriteVariable(-1, operation)
end

function squareVariable() --Squares  the variable to itself
	curVariable = 2 
	WriteVariable(-1, "sq")

	local x =  Solve(variable1, variable2, num)
	d.UI.Display.Text =x
	answer = x
	variable1 = x
	variable2 = "0"
	d.UI.Function.Text = ""
	num = "Unselected"
	curVariable = 3 
end

function SquareRootVariable() --Finds the square root of the variable
	curVariable = 2 
	WriteVariable(-1, "sqrt")

	local x =  Solve(variable1, variable2, num)
	d.UI.Display.Text =x
	answer = x
	variable1 = x
	variable2 = "0"
	d.UI.Function.Text = ""
	num = "Unselected"
	curVariable = 3 
end

function writeVariablePi()	--Sets the current variable to Pi
	local write = 9
	if curVariable == 1 then 
		variable1 = math.pi
		d.UI.Display.Text = variable1
	end
	if curVariable == 2 then 
		variable2 = math.pi
		d.UI.Display.Text = variable2
	end
	if curVariable == -1 then 
		variable2 = math.pi
		d.UI.Display.Text = variable2
	end
	if curVariable ==3 then 
		curVariable = 1 
		variable1 = ""
		variable2 = ""
		variable1 = math.pi
		d.UI.Display.Text = variable1
	end
end

function ConvertFtD() --Converts a fraction to a decimal
	if curVariable == 1 then 
		if not tostring(variable1):find("/") then 
			local numerator, denominator = decimalToFraction(variable1)
			variable1 = numerator .. "/" .. denominator
		else 
			local a = string.split(tostring(variable1), "/")
			variable1 = a[1]/a[2]
		end

		d.UI.Display.Text = variable1
	end
	if curVariable == 2 then 
		if not tostring(variable2):find("/") then 
			local numerator, denominator = decimalToFraction(variable2)
			variable2 = numerator .. "/" .. denominator
		else 
			local a = string.split(tostring(variable2), "/")
			variable2 = a[1]/a[2]
		end

		d.UI.Display.Text = variable2
	end


	if curVariable == 3 then 
		if not tostring(variable1):find("/") then 
			local numerator, denominator = decimalToFraction(variable1)
			variable1 = numerator .. "/" .. denominator
		else 
			local a = string.split(tostring(variable1), "/")
			variable1 = a[1]/a[2]
		end

		d.UI.Display.Text = variable1
	end
end
local function checkKeyCode(keycode, name) --Checks if the keycode matches either the primary or secondary keycode from the keycode settings
	if game.UserInputService:IsKeyDown(keycodes.Primary[name])  or game.UserInputService:IsKeyDown(keycodes.Secondary[name]) then 
		return true
	else 
		return false
	end
end


--						[	~USER KEYBOARD FUNCTIONALITY ~      ] 


game.UserInputService.InputBegan:Connect(function(input) --Sorts the user's inputs
	if d.Focused.Value == true then 

		local kc = input.KeyCode


		if checkKeyCode(kc, "0") then 
			writeNumber(0)
		end
		if checkKeyCode(kc, "1") then 
			writeNumber(1)
		end
		if checkKeyCode(kc, "2") then 
			writeNumber(2)
		end
		if checkKeyCode(kc, "3") then 
			writeNumber(3)
		end
		if checkKeyCode(kc, "4") then 
			writeNumber(4)
		end
		if checkKeyCode(kc, "5") then 
			writeNumber(5)
		end
		if checkKeyCode(kc, "6") then 
			writeNumber(6)
		end
		if checkKeyCode(kc, "7") then 
			writeNumber(7)
		end
		if checkKeyCode(kc, "8") then 
			writeNumber(8)
		end
		if checkKeyCode(kc, "9") then 
			writeNumber(9)
		end
		if checkKeyCode(kc, ".") then 
			writeDecimal()
		end
		if checkKeyCode(kc, "Clear") then 
			clear()
		end
		if checkKeyCode(kc, "FtD") then 
			ConvertFtD()
		end
		if checkKeyCode(kc, "Backspace") then 
			backspace()
		end
		if checkKeyCode(kc, "Enter") then 
			Submit()
		end
		if checkKeyCode(kc, "Add") then 
			writeOperation("add")
		end
		if checkKeyCode(kc, "Subtract") then 
			writeOperation("subtract")
		end
		if checkKeyCode(kc, "Multiply") then 
			writeOperation("multiply")
		end
		if checkKeyCode(kc, "Divide") then 
			writeOperation("divide")
		end
	end
end)



--						[	~USER CLICK FUNCTIONALITY ~      ] 


d.UI.clear.MouseButton1Down:Connect(function()
	if game.UserInputService:IsKeyDown(keycodes.Toggle) then 
		clearHistory()
	else 
		AskToClear()
	end
end)
d.UI.Buttons.C.MouseButton1Down:Connect(function()
	clear()
end)
d.UI.Buttons.CE.MouseButton1Down:Connect(function()
	clearEntry()
end)
d.UI.Buttons.back.MouseButton1Down:Connect(function()
	backspace()
end)
d.UI.Buttons["0"].MouseButton1Down:Connect(function()
	writeNumber(0)
end)
d.UI.Buttons["1"].MouseButton1Down:Connect(function()
	writeNumber(1)
end)
d.UI.Buttons["2"].MouseButton1Down:Connect(function()
	writeNumber(2)
end)
d.UI.Buttons["3"].MouseButton1Down:Connect(function()
	writeNumber(3)
end)
d.UI.Buttons["4"].MouseButton1Down:Connect(function()
	writeNumber(4)
end)
d.UI.Buttons["5"].MouseButton1Down:Connect(function()
	writeNumber(5)
end)
d.UI.Buttons["6"].MouseButton1Down:Connect(function()
	writeNumber(6)
end)
d.UI.Buttons["7"].MouseButton1Down:Connect(function()
	writeNumber(7)
end)
d.UI.Buttons["8"].MouseButton1Down:Connect(function()
	writeNumber(8)
end)
d.UI.Buttons["9"].MouseButton1Down:Connect(function()
	writeNumber(9)
end)
d.UI.Buttons["decimal"].MouseButton1Down:Connect(function()
	writeDecimal()
end)
d.UI.Buttons["negate"].MouseButton1Down:Connect(function()
	Negate()
end)
d.UI.Buttons["equals"].MouseButton1Down:Connect(function()
	Submit()
end)
d.UI.Buttons["add"].MouseButton1Down:Connect(function()
	writeOperation("add")
end)
d.UI.Buttons["subtract"].MouseButton1Down:Connect(function()
	writeOperation("subtract")
end)
d.UI.Buttons["multiply"].MouseButton1Down:Connect(function()
	writeOperation("multiply")
end)
d.UI.Buttons["divide"].MouseButton1Down:Connect(function()
	writeOperation("divide")
end)
d.UI.Buttons["squared"].MouseButton1Down:Connect(function()
	squareVariable()
end)
d.UI.Buttons["squareroot"].MouseButton1Down:Connect(function()
	SquareRootVariable()
end)
d.UI.Buttons["pi"].MouseButton1Down:Connect(function()
	writeVariablePi()
end)
d.UI.Buttons["convert"].MouseButton1Down:Connect(function()
	ConvertFtD()
end)


--						[	~USER HOVER FUNCTIONALITY ~      ] 

local hovering=nil
for _, v in pairs(d:GetDescendants()) do 
	if v:IsA("TextButton") and v.FontFace.Bold == false  then 
		v.MouseEnter:Connect(function()
			v.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
			 hovering =true
			
		end)
		v.MouseLeave:Connect(function()
			 hovering = false
			v.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
		end)
	end
end
