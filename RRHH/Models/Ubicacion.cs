namespace RRHH.Models
{
    public class Ubicacion
    {
        public Ubicacion()
        {
        }

        public Ubicacion(int ubi_codigo, string ubi_descripcion)
        {
            codigo = ubi_codigo;
            descripcion = ubi_descripcion;

        }

        public int codigo { get; set; }

        public string descripcion { get; set; }

    }
}
