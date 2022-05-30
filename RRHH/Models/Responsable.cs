namespace RRHH.Models
{
    public class Responsable
    {
        public Responsable()
        {
        }

        public Responsable(int resp_id, string resp_descripcion)
        {
            id = resp_id;
            descripcion = resp_descripcion;

        }

        public int id { get; set; }

        public string descripcion { get; set; }
    }
}
