
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY . .

FROM build AS publish
RUN dotnet publish "CrystalSkin.Api\CrystalSkin.Api.csproj" -c Release -o /app
FROM base AS final
WORKDIR /app
COPY --from=publish /app .

ENTRYPOINT ["dotnet", "CrystalSkin.Api.dll", "--urls", "http://0.0.0.0:80"]