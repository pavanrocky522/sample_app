# Use the official .NET 8 SDK image to build the application
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# Use the .NET 8 SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["sampleapp/sampleapp.csproj", "sampleapp/"]
RUN dotnet restore "sampleapp/sampleapp.csproj"
COPY . .
WORKDIR "/src/sampleapp"
RUN dotnet build "sampleapp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "sampleapp.csproj" -c Release -o /app/publish

# Copy the build output to the base image and set the entry point
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "sampleapp.dll"]