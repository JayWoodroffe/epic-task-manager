
using System.Security.Cryptography;
using Microsoft.AspNetCore.Cryptography.KeyDerivation;

namespace KanbanApi.Helpers;
public static class PasswordHasher
{
    //hash a password - use when registering a new user
    public static string HashPassword(string password)
    {
        //generate a random salt
        byte[] salt = RandomNumberGenerator.GetBytes(128/8); //128-bit salt

        // Derive a key from the password and salt
        String hashed = Convert.ToBase64String(KeyDerivation.Pbkdf2(
            password: password,
            salt: salt,
            prf: KeyDerivationPrf.HMACSHA256,
            iterationCount: 10000,
            numBytesRequested: 32));
       
        // Convert to Base64 string
        return $"{Convert.ToBase64String(salt)}.{hashed}";
    }

    //verify a password against a stored hash - use when logging in
    public static bool VerifyPassword(string password, string hashedPassword)
    {
        // Split the stored hash into salt and hash
        var parts = hashedPassword.Split('.');
        if (parts.Length != 2)
            return false;

        byte[] salt = Convert.FromBase64String(parts[0]);
        string hash = parts[1];


        // Derive the key from the provided password and the stored salt
        string hashedInput = Convert.ToBase64String(KeyDerivation.Pbkdf2(
            password: password,
            salt: salt,
            prf: KeyDerivationPrf.HMACSHA256,
            iterationCount: 10000,
            numBytesRequested: 32));
        // Compare the hashes
        return hash == hashedInput;
    }

}