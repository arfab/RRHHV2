namespace RRHH.Models
{
    public class TipoCantidadHoras
    {

        public TipoCantidadHoras()
        {
        }

        public TipoCantidadHoras(int tipo_id, string tipo_descripcion)
        {
            id = tipo_id;
            descripcion = tipo_descripcion;
        }

        public int id { get; set; }

        public string descripcion { get; set; }

    }
}
