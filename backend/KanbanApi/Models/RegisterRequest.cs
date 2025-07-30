namespace KanbanApi.Models;


public class RegisterRequest
{
    public string Email { get; set; }
    public string Password { get; set; }
    public string ConfirmPassword { get; set; }
    public string FullName { get; set; }

    public RegisterRequest() { }

    public RegisterRequest(string email, string password, string confirmPassword, string fullName)
    {
        Email = email;
        Password = password;
        ConfirmPassword = confirmPassword;
        FullName = fullName;
    }

    //public RegisterRequest() { } // Parameterless constructor for deserialization
}
