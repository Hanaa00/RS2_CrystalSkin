﻿namespace CrystalSkin.Services;
public interface IRabbitMQProducer
{
    public void SendMessage<T>(T message);
}

