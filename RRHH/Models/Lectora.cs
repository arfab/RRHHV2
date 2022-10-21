namespace RRHH.Models
{
    public class Lectora
    {

        public Lectora()
        {
        }

        public Lectora(int l_id, string l_descripcion)
        {
            id = l_id;
            descripcion = l_descripcion;
        }

        public int id { get; set; }

        public string? descripcion { get; set; }

        public string? ip { get; set; }

        public DateTime ultima_actualizacion { get; set; }

        public int horas { get; set; }

        public int empresa_id { get; set; }

    }
}
