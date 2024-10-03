FROM mcr.microsoft.com/mssql/server:2022-latest

EXPOSE 1433

# Run SQL Server process.
CMD [ "/opt/mssql/bin/sqlservr" ]




