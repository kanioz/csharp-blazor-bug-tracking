FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["BugTrackerUI/BugTrackerUI.csproj", "BugTrackerUI/"]
RUN dotnet restore "BugTrackerUI/BugTrackerUI.csproj"
COPY . .
WORKDIR "/src/BugTrackerUI"
RUN dotnet build "BugTrackerUI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "BugTrackerUI.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BugTrackerUI.dll"]