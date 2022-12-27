namespace RRHH.Models
{
    public class Anio
    {

        public Anio()
        {
        }

        public Anio(int g_id, string g_descripcion)
        {
            id = g_id;
            descripcion = g_descripcion;
        }
        public int id { get; set; }

        public string descripcion { get; set; }

    }
}
