namespace RRHH.Models
{
    public class TipoJustificacion
    {
        public TipoJustificacion()
        {
        }

        public TipoJustificacion(int tipo_id, string tipo_descripcion, string tipo_observacion, int tipo_pago)
        {
            id = tipo_id;
            descripcion = tipo_descripcion;
            observacion = tipo_observacion;
            pago = tipo_pago;
        }

        public int id { get; set; }

        public string descripcion { get; set; }

        public string observacion { get; set; }

        public int pago { get; set; }
    }
}
