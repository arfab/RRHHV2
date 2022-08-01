namespace RRHH.Models
{
    public class PerfilWeb
    {

        public PerfilWeb()
        {
        }

        public PerfilWeb(int perfil_id, string perfil_descripcion)
        {
            id = perfil_id;
            descripcion = perfil_descripcion;
        }

        public int id { get; set; }

        public string descripcion { get; set; }

        public int perfil_id { get; set; }

    }
}
