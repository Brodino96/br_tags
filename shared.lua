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