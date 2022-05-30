namespace RRHH.Models
{
    public class Responsable
    {
        public Responsable()
        {
        }

        public Responsable(int resp_id, string resp_apellido, string resp_nombre)
        {
            id = resp_id;
            apellido = resp_apellido;
            nombre = resp_nombre;

        }

        public int id { get; set; }

        public string apellido { get; set; }

        public string nombre { get; set; }
    }
}
