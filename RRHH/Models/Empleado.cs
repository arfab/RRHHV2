namespace RRHH.Models
{
    public class Empleado
    {

        public Empleado()
        {
        }

        public Empleado(int e_id, string e_descripcion)
        {
            id = e_id;
            descripcion = e_descripcion;
        }
        public int id { get; set; }

        public string descripcion { get; set; }

    }
}
