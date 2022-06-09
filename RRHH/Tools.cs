namespace RRHH
{
    public class Tools
    {
        public static string GetConnectionString(string name = "DefaultConnection")
        {

            IConfigurationBuilder builder = new ConfigurationBuilder()
                                        .SetBasePath(Directory.GetCurrentDirectory())
                                        .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true);

            IConfigurationRoot configuration = builder.Build();
            IConfigurationSection sConnString = configuration.GetSection("DB").GetSection("conn");

            return sConnString.Value;

            //return "Data Source=190.210.248.41;Initial Catalog=MontagneAdministracionTest;Persist Security Info=True;User ID=usersimon;Password=bialcohol3.2021";
        }

        public static string GetPaginacionNovedad()
        {

            IConfigurationBuilder builder = new ConfigurationBuilder()
                                        .SetBasePath(Directory.GetCurrentDirectory())
                                        .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true);

            IConfigurationRoot configuration = builder.Build();
            IConfigurationSection sPaginacionNovedad = configuration.GetSection("Parametros").GetSection("paginacion_novedad");

            return sPaginacionNovedad.Value;

        }

        public static string sObtenerMes(int iMes)
        {
            string sRet = "";
            switch (iMes)
            {
                case 1:
                    {
                        sRet = "Enero";
                        break;
                    }

                case 2:
                    {
                        sRet = "Febrero";
                        break;
                    }

                case 3:
                    {
                        sRet = "Marzo";
                        break;
                    }

                case 4:
                    {
                        sRet = "Abril";
                        break;
                    }

                case 5:
                    {
                        sRet = "Mayo";
                        break;
                    }

                case 6:
                    {
                        sRet = "Junio";
                        break;
                    }

                case 7:
                    {
                        sRet = "Julio";
                        break;
                    }

                case 8:
                    {
                        sRet = "Agosto";
                        break;
                    }

                case 9:
                    {
                        sRet = "Setiembre";
                        break;
                    }

                case 10:
                    {
                        sRet = "Octubre";
                        break;
                    }

                case 11:
                    {
                        sRet = "Noviembre";
                        break;
                    }

                case 12:
                    {
                        sRet = "Diciembre";
                        break;
                    }
            }

            return sRet;
        }


    }
}

