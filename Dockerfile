# Use the official .NET SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the project files into the container
COPY . ./

# Restore project dependencies
RUN dotnet restore

# Build the application in Release mode
RUN dotnet publish -c Release -o /app/out

# Use a smaller runtime image for the final stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

# Set the working directory inside the runtime image
WORKDIR /app

# Copy the built application from the build stage
COPY --from=build /app/out ./

# Expose port 80
EXPOSE 80

# Set the entry point to run the application
ENTRYPOINT ["dotnet", "sampleapp.dll"]
