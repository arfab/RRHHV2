namespace RRHH.Models
{
    public class Sector
    {
        public Sector()
        {
        }

        public Sector(int sec_id, string sec_descripcion, int sec_ubicacion_id, string sec_ubicacion)
        {
            id = sec_id;
            descripcion = sec_descripcion;
            ubicacion_id = sec_ubicacion_id;
            ubicacion = sec_ubicacion;

        }

        public int id { get; set; }

        public string descripcion { get; set; }

        public int ubicacion_id { get; set; }

        public string ubicacion { get; set; }

    }
}
