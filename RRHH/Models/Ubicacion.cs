namespace RRHH.Models
{
    public class Ubicacion
    {
        public Ubicacion()
        {
        }

        public Ubicacion(int ubi_id, string ubi_descripcion)
        {
            id = ubi_id;
            descripcion = ubi_descripcion;

        }

        public int id { get; set; }

        public string descripcion { get; set; }

    }
}
