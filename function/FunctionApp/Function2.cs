using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;

namespace FunctionApp
{
    public static class Function2
    {
        [FunctionName("Function2")]
        [return: Queue("functionqueue")]

        public static string Run([ServiceBusTrigger("functiontop","functionsub",Connection = "AzureWebJobsServiceBus")]string mySbMsg, ILogger log)
        {
            log.LogInformation($"C# ServiceBus topic trigger function processed message: {mySbMsg}");
            return mySbMsg;
        }
    }
}
