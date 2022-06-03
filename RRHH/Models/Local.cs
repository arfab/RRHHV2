namespace RRHH.Models
{
    public class Local
    {
        public Local()
        {
        }

        public Local(int l_id, string l_descripcion)
        {
            id = l_id;
            descripcion = l_descripcion;
        }
        public int id { get; set; }

        public string descripcion { get; set; }
    }
}

