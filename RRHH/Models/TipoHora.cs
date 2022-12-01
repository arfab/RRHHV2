namespace RRHH.Models
{
    public class TipoHora
    {

        public TipoHora()
        {
        }

        public TipoHora(int tipo_id, string tipo_descripcion)
        {
            id = tipo_id;
            descripcion = tipo_descripcion;
        }

        public int id { get; set; }

        public string descripcion { get; set; }
    }
}
