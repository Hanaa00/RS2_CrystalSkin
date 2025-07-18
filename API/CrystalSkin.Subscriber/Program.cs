﻿
var factory = new ConnectionFactory
{
    HostName = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "localhost",
    Port = int.Parse(Environment.GetEnvironmentVariable("RABBITMQ_PORT") ?? "5672"),
    UserName = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest",
    Password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest",
};
factory.ClientProvidedName = "Rabbit Test Consumer";
IConnection connection = factory.CreateConnection();
IModel channel = connection.CreateModel();

string exchangeName = "EmailExchange";
string routingKey = "email_queue";
string queueName = "EmailQueue";

channel.ExchangeDeclare(exchangeName, ExchangeType.Direct);
channel.QueueDeclare(queueName, true, false, false, null);
channel.QueueBind(queueName, exchangeName, routingKey, null);

var consumer = new EventingBasicConsumer(channel);

consumer.Received += (sender, args) =>
{
    var body = args.Body.ToArray();
    string message = Encoding.UTF8.GetString(body);
    var emailData = JsonConvert.DeserializeObject<EmailModel>(message);
    if (emailData != null)
    {
        Console.WriteLine($"Message received: {message}");
        IEmail emailService = new Email();
        emailService.Send(emailData.Title, emailData.Body, emailData.Email);

        channel.BasicAck(args.DeliveryTag, false);
    }
    else
    {
        Console.WriteLine($"Problem when sending mail: {message}");
    }
};

channel.BasicConsume(queueName, false, consumer);

Console.WriteLine("Waiting for messages. Press Q to quit.");

Thread.Sleep(Timeout.Infinite);

channel.Close();
connection.Close();
