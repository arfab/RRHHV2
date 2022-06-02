namespace RRHH.Models
{
    public class Perfil
    {
        public Perfil()
        {
        }

        public Perfil(int perfil_id, string perfil_descripcion)
        {
            id = perfil_id;
            descripcion = perfil_descripcion;
        }

        public int id { get; set; }

        public string descripcion { get; set; }
    }
}
