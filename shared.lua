Shared = {
    ---Checks the type of the first variable and if it matches the second it returns true
    ---@return boolean
    ---@param variable any The variable that have to match the type
    ---@param targetType string The tag or list of tags that have to match
    ---@param functionName string The name of the function called
    type = function (variable, targetType, functionName)
        local match = type(variable)

        if match == targetType then
            return true
        end

        Debug.error(string.format("Function: '%s': was expecting [%s] but got [%s]", functionName, targetType, match), true)

        return false
    end
}

Debug = {
    ---@return nil
    ---@param text string|number The text that needs to be printed
    ---@param bypass boolean If Config.debug should be bypassed
    ---@param line integer|nil Current line of code
    success = function (text, bypass, line)
        if Config.debug or bypass then
            return print(string.format("%d [^2SUCCESS^0] %s", line, tostring(text)))
            --return print("[^2SUCCESS at line ^0"..line.."] "..tostring(text))
        end
    end,
    ---@return nil
    ---@param text string|number The text that needs to be printed
    ---@param bypass boolean If Config.debug should be bypassed
    ---@param line integer|nil Current line of code
    info = function (text, bypass, line)
        if Config.debug or bypass then
            return print(string.format("%d [^3INFO^0] %s", line, tostring(text)))
            --return print("[^3INFO at line ^0"..line.."] "..tostring(text))
        end
    end,
    ---@return nil
    ---@param text string|number The text that needs to be printed
    ---@param bypass boolean If Config.debug should be bypassed
    ---@param line integer|nil Current line of code
    error = function (text, bypass, line)
        if Config.debug or bypass then
            return print(string.format("%d [^1ERROR^0] %s", line, tostring(text)))
            --return print("[^1ERROR at line ^0"..line.."] "..tostring(text))
        end
    end
}