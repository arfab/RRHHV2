namespace RRHH.Models
{
    public class Funcion
    {
        public Funcion()
        {
        }

        public Funcion(int f_id, string f_descripcion)
        {
            id = f_id;
            descripcion = f_descripcion;
        }
        public int id { get; set; }

        public string descripcion { get; set; }
    }
}

