namespace RRHH.Models
{
    public class Sector
    {
        public Sector()
        {
        }

        public Sector(int sec_id, string sec_descripcion)
        {
            id = sec_id;
            descripcion = sec_descripcion;

        }

        public int id { get; set; }

        public string descripcion { get; set; }

    }
}
