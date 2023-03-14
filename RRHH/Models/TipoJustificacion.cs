namespace RRHH.Models
{
    public class TipoJustificacion
    {
        public TipoJustificacion()
        {
        }

        public TipoJustificacion(int tipo_id, 
                                 string tipo_descripcion, 
                                 string tipo_observacion, 
                                 int tipo_pago, 
                                 int tipo_mes_completo,
                                 int tipo_presentismo,
                                 int tipo_puntualidad,
                                 int tipo_horas,
                                 int tipo_presentismo_comercio
                                 )
        {
            id = tipo_id;
            descripcion = tipo_descripcion;
            observacion = tipo_observacion;
            pago = tipo_pago;
            mes_completo = tipo_mes_completo;
            pre_presentismo= tipo_presentismo;
            pre_puntualidad = tipo_puntualidad;
            pre_horas = tipo_horas;
            pre_presentismo_comercio = tipo_presentismo;
        }

        public int id { get; set; }

        public string descripcion { get; set; }

        public string observacion { get; set; }

        public int pago { get; set; }

        public int mes_completo { get; set; }

        public int pre_presentismo { get; set; }
        public int pre_puntualidad { get; set; }
        public int pre_horas { get; set; }
        public int pre_presentismo_comercio { get; set; }
    }
}
