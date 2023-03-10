using RRHH.Models;

namespace RRHH.Repository
{
    public interface ILiquidacionRepo
    {
        public Liquidacion Obtener(Int64 id);

        public IEnumerable<Liquidacion> ObtenerTodos();

        public IEnumerable<LiquidacionDetalle> ObtenerDetalle(int anio, int mes, int empresa_id, int ubicacion_id, int sector_id, int legajo_id, DateTime fecha_desde, DateTime fecha_hasta);

        public string Generar(int empresa_id, int ubicacion_id, int sector_id, int legajo_id, int usuario_id);

        public string Cerrar(int usuario_id);

        public string Modificar(Liquidacion liquidacion);

    }
}
