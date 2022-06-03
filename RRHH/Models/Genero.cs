namespace RRHH.Models
{
    public class Genero
    {
        public Genero()
        {
        }

        public Genero(int g_id, string g_descripcion)
        {
            id = g_id;
            descripcion = g_descripcion;
        }
        public int id { get; set; }

        public string descripcion { get; set; }
    }
}
