Shared = {
    ---Checks the type of the first variable and if it matches the second it returns true
    ---@return boolean
    ---@param variable any The variable that have to match the type
    ---@param targetType string|table The tag or list of tags that have to match
    type = function (variable, targetType)
        local t = type(variable)

        if type(targetType) == "table" then
            for i = 1, #targetType do
                if targetType[i] == t then
                    return true
                end
            end
            print("Was expecting a string but recived type: "..t)
            return false

        else
            if t == targetType then
                return true
            else
                print("Was expecting a string but recived type: "..t)
                return false
            end
        end
    end
}

Debug = {
    ---@return nil
    ---@param text string|number The text that needs to be printed
    ---@param bypass boolean If Config.debug should be bypassed
    ---@param line integer Current line of code
    success = function (text, bypass, line)
        if Config.debug or bypass then
            return print(line.."[^2SUCCESS at line ^0"..line.."] "..tostring(text))
        end
    end,
    ---@return nil
    ---@param text string|number The text that needs to be printed
    ---@param bypass boolean If Config.debug should be bypassed
    ---@param line integer Current line of code
    info = function (text, bypass, line)
        if Config.debug or bypass then
            return print(line.."[^3INFO at line ^0"..line.."] "..tostring(text))
        end
    end,
    ---@return nil
    ---@param text string|number The text that needs to be printed
    ---@param bypass boolean If Config.debug should be bypassed
    ---@param line integer Current line of code
    error = function (text, bypass, line)
        if Config.debug or bypass then
            return print(line.."[^1ERROR at line ^0"..line.."] "..tostring(text))
        end
    end
}