    /// <summary>
    /// Converts a Vector3 string to a valid Vector 3
    /// </summary>
    /// <param name="vectorString">(0.1,0.2,0.3)</param>
    /// <returns>Vector3(0.1, 0.2, 0.3)</returns>
    public static UnityEngine.Vector3 StringToVector3(this string vectorString)
    {
        try
        {
            // Remove the brackets.  Some methods are legacy and already have () removed
            // Adding this in as a safeguard for those that correctly do not already have it removed
            if (vectorString.StartsWith("(") && vectorString.EndsWith(")"))
            {
                vectorString = vectorString[1..^1]; //vectorString.Substring(1, vectorString.Length-2);
            }

            // split the string
            string[] splitVector = vectorString.Split(',');

            // create the vector from the split string
            UnityEngine.Vector3 result = new(
                float.Parse(splitVector[0]),
                float.Parse(splitVector[1]),
                float.Parse(splitVector[2]));

            return result;
        } catch (Exception ex)
        {
            UnityEngine.Debug.LogError($"The data input was invalid {ex}");
            return new UnityEngine.Vector3(0, 0, 0); // return 0,0,0 because we have to for the error
        }
    }

    // Usage
    string pos = "(0,0,0)";
    pos.StringToVector3();