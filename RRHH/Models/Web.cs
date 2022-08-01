namespace RRHH.Models
{
    public class Web
    {

        public Web()
        {
        }

        public Web(string web_id, string web_descripcion)
        {
            id = web_id;
            descripcion = web_descripcion;
        }

        public string nombre { get; set; }

        public string url { get; set; }

        public string home_page { get; set; }

        public int? perfil_id { get; set; }
        public string? perfil { get; set; }

        public string id { get; set; }

        public string descripcion { get; set; }
    }
}
