namespace RRHH.Models
{
    public class CentroCosto
    {
        public CentroCosto()
        {
        }

        public CentroCosto(int f_id, string f_descripcion)
        {
            id = f_id;
            descripcion = f_descripcion;
        }
        public int id { get; set; }

        public string descripcion { get; set; }
    }
}

