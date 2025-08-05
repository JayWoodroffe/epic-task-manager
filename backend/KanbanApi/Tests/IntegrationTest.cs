using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Threading.Tasks;
using backend;
using backend.Models;
using Microsoft.AspNetCore.Mvc.Testing;
using Xunit;

namespace KanbanApi.Tests
{
    //integration test for project-related functionality
    public class IntegrationTest : IClassFixture<WebApplicationFactory<Startup>>
    {
        private readonly HttpClient _client;

        //setup the test client using the WebApplicationFactory
        public IntegrationTest(WebApplicationFactory<Startup> factory)
        {
            _client = factory.CreateClient();
        }


        private async Task<string> GetUserToken()
        {
            var response = await _client.PostAsJsonAsync("/api/auth/login", new LoginModel
            {
                Email = "emaileg@gmail.com", 
                Password = "MySecret123!"     
            });

            response.EnsureSuccessStatusCode();

            var content = await response.Content.ReadFromJsonAsync<Dictionary<string, string>>();
            return content["token"];
        }

        //helper method to get an authentication token for a test user
        private async Task<string> GetAuthToken()
        {
            var email = "flowtest@example.com";
            var password = "Flow@123";

            //register user
            await _client.PostAsJsonAsync("/api/auth/register", new RegisterModel
            {
                FullName = "Flow User",
                Email = email,
                Password = password,
                ConfirmPassword = password
            });

            //login user to receive jwt token
            var response = await _client.PostAsJsonAsync("/api/auth/login", new LoginModel
            {
                Email = email,
                Password = password
            });

            response.EnsureSuccessStatusCode(); //fail the test if the response is not successful
            //read the token from the response content
            var content = await response.Content.ReadFromJsonAsync<Dictionary<string, string>>();
            return content["token"];
        }

        //endpoint should be accessible only to authenticated users (and admins specifically)
        [Fact]
        public async Task GetProjects_ReturnsList_ForAdminUser()
        {
            var token = await GetAdminToken(); //uses proper admin token
            _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            var response = await _client.GetAsync("/api/projects");

            response.EnsureSuccessStatusCode();

            var json = await response.Content.ReadAsStringAsync();
            Assert.Contains("projects", json.ToLower());
        }


        [Fact]
        public async Task GetMyProjects_ReturnsList_ForRegularUser()
        {
            var token = await GetUserToken();
            _client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

            var response = await _client.GetAsync("/api/projects/myprojects");

            response.EnsureSuccessStatusCode();

            var json = await response.Content.ReadAsStringAsync();
            Assert.Contains("projects", json.ToLower());
        }
    }
}
