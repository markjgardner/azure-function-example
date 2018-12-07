using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;

namespace FunctionApp
{
    public static class Function2
    {
        [FunctionName("Function2")]
<<<<<<< HEAD
        [return: Queue("functionqueue")]

        public static string Run([ServiceBusTrigger("functiontop","functionsub",Connection = "AzureWebJobsServiceBus")]string mySbMsg, ILogger log)
        {
            log.LogInformation($"C# ServiceBus topic trigger function processed message: {mySbMsg}");
            return mySbMsg;
=======
        public static void Run([ServiceBusTrigger("functiontop","functionsub",Connection = "AzureWebJobsServiceBus")]string mySbMsg, ILogger log)
        {
            log.LogInformation($"C# ServiceBus topic trigger function processed message: {mySbMsg}");
>>>>>>> 62ab2f2bac0a9adbd714c042be144b77f1999baf
        }
    }
}
