FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443
EXPOSE 5000

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["Connect.Apps.csproj", "./"]
RUN dotnet restore "Connect.Apps.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "Connect.Apps.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Connect.Apps.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Connect.Apps.dll"]
