namespace RRHH.Models
{
    public class TipoFeriado
    {

        public TipoFeriado()
        {
        }

        public TipoFeriado(string tipo_codigo, string tipo_descripcion, int tipo_orden)
        {
            codigo = tipo_codigo;
            descripcion = tipo_descripcion;
            orden = tipo_orden;
        }

        
        
        public string codigo { get; set; }

        public string descripcion { get; set; }

        public int orden { get; set; }
    }
}
