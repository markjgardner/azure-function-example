using Microsoft.AspNetCore.Http;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;

namespace FunctionApp
{
    public static class Function1
    {
        [FunctionName("Function1")]
        [return: ServiceBus("functiontop", Connection = "AzureWebJobsServiceBus")]
        public static string Run([HttpTrigger(AuthorizationLevel.Function, "get", Route = null)]HttpRequest req, ILogger log)
        {
            string message = req.Query["message"];
            log.LogInformation($"C# HTTP trigger function processed a request. Queued message: {message}");
            return message;
        }
    }
}
