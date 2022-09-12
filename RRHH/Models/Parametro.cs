namespace RRHH.Models
{
    public class Parametro
    {

        public Parametro()
        {
        }

        public Parametro(string p_codigo, string p_descripcion, string p_valor)
        {
            codigo = p_codigo;
            descripcion = p_descripcion;
            valor = p_valor;
        }

        public string codigo { get; set; }

        public string descripcion { get; set; }

        public string valor { get; set; }

    }
}
