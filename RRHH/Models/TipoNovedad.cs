namespace RRHH.Models
{
    public class TipoNovedad
    {

        public TipoNovedad()
        {
        }

        public TipoNovedad(int tipo_id, string tipo_descripcion)
        {
            id = tipo_id;
            descripcion = tipo_descripcion;
        }
 
        public int id { get; set; }

        public string descripcion { get; set; }
    }
}
